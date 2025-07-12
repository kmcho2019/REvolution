module TopModule (
    input  clk,
    input  reset,
    input  x,
    output reg z
);

    reg [2:0] state, next_state;

    localparam S0 = 3'b000,
               S1 = 3'b001,
               S2 = 3'b010,
               S3 = 3'b011,
               S4 = 3'b100;

    always @(posedge clk) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            S0: begin
                z = 0;
                next_state = x ? S1 : S0;
            end
            S1: begin
                z = 0;
                next_state = x ? S4 : S1;
            end
            S2: begin
                z = 0;
                next_state = x ? S1 : S2;
            end
            S3: begin
                z = 1;
                next_state = x ? S2 : S1;
            end
            S4: begin
                z = 1;
                next_state = x ? S4 : S3;
            end
            default: begin
                z = 0;
                next_state = S0;
            end
        endcase
    end

endmodule