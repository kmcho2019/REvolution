module TopModule(
    input clk,
    input reset,
    input in,
    output done
);

reg [7:0] data;
reg [2:0] state;
reg [2:0] nextState;
reg [3:0] bitCounter;
reg doneReg;

localparam IDLE = 3'b001;
localparam START = 3'b010;
localparam DATA = 3'b011;
localparam STOP = 3'b100;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        data <= 8'b0;
        bitCounter <= 4'b0;
        doneReg <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (!in) begin
                    state <= START;
                    bitCounter <= 4'b1;
                end else begin
                    state <= IDLE;
                end
            end
            START: begin
                state <= DATA;
                data[0] <= in;
            end
            DATA: begin
                if (bitCounter < 4'b1000) begin
                    data <= {data[6:0], in};
                    bitCounter <= bitCounter + 1'b1;
                end else begin
                    data <= {data[6:0], in};
                    state <= STOP;
                end
            end
            STOP: begin
                if (in) begin
                    doneReg <= 1'b1;
                    state <= IDLE;
                    data <= 8'b0;
                    bitCounter <= 4'b0;
                end else begin
                    state <= STOP;
                end
            end
        endcase
    end
end

always @(posedge clk) begin
    done <= doneReg;
    doneReg <= 1'b0;
end

endmodule