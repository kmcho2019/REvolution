module TopModule(
    input         clk,
    input         in,
    input         reset,
    output [7:0]  out_byte,
    output        done
);

reg [7:0] data;
reg [2:0] state;
reg [2:0] nextState;
reg [3:0] bitCounter;
reg doneReg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        doneReg <= 0;
        data <= 8'd0;
        bitCounter <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (!in) begin // Start bit detected
                    state <= 1;
                    bitCounter <= 1;
                end else if (in) begin // Stop bit detected, wait for start bit
                    state <= 0;
                end
            end
            1: begin // RECEIVE
                data <= {data[6:0], in};
                if (bitCounter == 8) begin // All data bits received
                    state <= 2;
                end else begin
                    bitCounter <= bitCounter + 1;
                end
            end
            2: begin // STOP
                if (in) begin // Stop bit verified
                    state <= 0;
                    doneReg <= 1;
                end else begin // Stop bit not verified, wait for stop bit
                    state <= 2;
                end
            end
            default: state <= 0;
        endcase
    end
end

assign out_byte = data;
assign done = doneReg;

always @(posedge clk) begin
    if (state == 2 && in) begin // Stop bit verified
        doneReg <= 0;
    end
end

endmodule