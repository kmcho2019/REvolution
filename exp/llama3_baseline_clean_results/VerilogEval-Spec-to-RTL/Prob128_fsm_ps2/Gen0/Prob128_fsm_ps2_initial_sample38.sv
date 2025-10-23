module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output done
);

reg [1:0] state;
reg [1:0] nextState;
reg done_reg;

// Define the states
localparam IDLE = 2'b00;
localparam BYTE1 = 2'b01;
localparam BYTE2 = 2'b10;
localparam BYTE3 = 2'b11;

always @(*) begin
    case (state)
        IDLE: begin
            if (in[3] == 1'b1)
                nextState = BYTE1;
            else
                nextState = IDLE;
        end
        BYTE1: nextState = BYTE2;
        BYTE2: nextState = BYTE3;
        BYTE3: nextState = IDLE;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        done_reg <= 1'b0;
    end else begin
        state <= nextState;
        if (state == BYTE3) begin
            done_reg <= 1'b1;
        end else begin
            done_reg <= 1'b0;
        end
    end
end

assign done = done_reg;

endmodule