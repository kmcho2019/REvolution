module TopModule(
    input       clk,
    input       reset,
    input       in,
    output      done
);

reg [7:0]      data;
reg [2:0]      state;
reg [2:0]      nextState;
reg [3:0]      bitCount;
reg           doneReg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 3'b000; // Idle
        data <= 8'd0;
        bitCount <= 4'd0;
        doneReg <= 1'b0;
    end else begin
        case (state)
            3'b000: begin // Idle
                if (!in) begin // Start bit detected
                    state <= 3'b001; // Start
                    bitCount <= 4'd1;
                    data[0] <= in;
                end else begin
                    state <= 3'b000; // Stay in Idle
                end
            end
            3'b001: begin // Start
                state <= 3'b010; // Data
                bitCount <= bitCount + 1;
                data[bitCount-1] <= in;
            end
            3'b010: begin // Data
                if (bitCount < 8) begin
                    state <= 3'b010; // Data
                    bitCount <= bitCount + 1;
                    data[bitCount-1] <= in;
                end else begin
                    state <= 3'b011; // Stop
                end
            end
            3'b011: begin // Stop
                if (in) begin // Valid stop bit
                    state <= 3'b000; // Idle
                    doneReg <= 1'b1;
                end else begin // Invalid stop bit, wait for stop bit
                    state <= 3'b011; // Stay in Stop
                end
            end
        endcase
    end
end

assign done = doneReg;

always @(posedge clk) begin
    if (state == 3'b000 && doneReg) begin
        doneReg <= 1'b0;
    end
end

endmodule