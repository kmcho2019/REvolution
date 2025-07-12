module TopModule(
    input clk,
    input aresetn,
    input x,
    output reg z
);

reg [1:0] current_state;
localparam S0 = 2'b00;
localparam S1 = 2'b01;
localparam S2 = 2'b10;

always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        current_state <= S0;
    end else begin
        case (current_state)
            S0: begin
                if (x) begin
                    current_state <= S1;
                end else begin
                    current_state <= S0;
                end
            end
            S1: begin
                if (~x) begin
                    current_state <= S2;
                end else begin
                    current_state <= S1;
                end
            end
            S2: begin
                if (x) begin
                    current_state <= S1;
                end else begin
                    current_state <= S0;
                end
            end
        endcase
    end
end

always @(*) begin
    case (current_state)
        S0: z = 0;
        S1: z = 0;
        S2: z = x;
    endcase
end

endmodule