module TopModule(
    input clk,
    input aresetn,
    input x,
    output reg z
);

reg [1:0] state; // 3 states: 2 bits

localparam S0 = 2'b00; // initial state
localparam S1 = 2'b01; // after detecting the first '1'
localparam S2 = 2'b10; // after detecting the '0' following the first '1'

always @(*) begin
    case(state)
        S0: z = 1'b0;
        S1: z = 1'b0;
        S2: z = x;
        default: z = 1'b0;
    endcase
end

always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin // asynchronous reset
        state <= S0;
    end else begin
        case(state)
            S0: begin
                if (x) begin
                    state <= S1;
                end else begin
                    state <= S0;
                end
            end
            S1: begin
                if (!x) begin
                    state <= S2;
                end else begin
                    state <= S1;
                end
            end
            S2: begin
                if (x) begin
                    state <= S1;
                end else begin
                    state <= S0;
                end
            end
            default: state <= S0;
        endcase
    end
end

endmodule