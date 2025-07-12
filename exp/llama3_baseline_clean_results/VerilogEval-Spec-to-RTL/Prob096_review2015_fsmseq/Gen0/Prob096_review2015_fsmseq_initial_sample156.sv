module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [1:0] state; // 0: Idle, 1: Found_1, 2: Found_11, 3: Found_110
localparam Idle = 2'b00;
localparam Found_1 = 2'b01;
localparam Found_11 = 2'b10;
localparam Found_110 = 2'b11;
localparam Found = 2'b12; // Not directly used, used as a flag for finding sequence

always @(posedge clk) begin
    if (reset) begin
        state <= Idle;
        start_shifting <= 0;
    end else begin
        case(state)
            Idle: begin
                if (data == 1) state <= Found_1;
            end
            Found_1: begin
                if (data == 1) state <= Found_11;
                else state <= Idle;
            end
            Found_11: begin
                if (data == 0) state <= Found_110;
                else state <= Found_1;
            end
            Found_110: begin
                if (data == 1) begin
                    state <= Idle; // or can use Found state if we need to use it for something else
                    start_shifting <= 1;
                end else state <= Idle;
            end
            default: state <= Idle;
        endcase
    end
end

endmodule