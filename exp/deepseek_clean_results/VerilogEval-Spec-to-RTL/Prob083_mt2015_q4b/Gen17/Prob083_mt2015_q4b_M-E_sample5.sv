module TopModule (
    input x,
    input y,
    output reg z
);
    reg [1:0] state;
    
    // State encoding
    localparam S0 = 2'b00;
    localparam S1 = 2'b01;
    localparam S2 = 2'b10;
    
    always @(x or y) begin
        case (state)
            S0: begin
                if (x & y) begin
                    state <= S1;
                    z <= 1;
                end
                else if (x | y) begin
                    state <= S2;
                    z <= 0;
                end
                else begin
                    z <= 1;
                end
            end
            S1: begin
                if (~x & ~y) begin
                    state <= S0;
                    z <= 1;
                end
                else if (x ^ y) begin
                    state <= S2;
                    z <= 0;
                end
                else begin
                    z <= 1;
                end
            end
            S2: begin
                if (x & y) begin
                    state <= S1;
                    z <= 1;
                end
                else if (~x & ~y) begin
                    state <= S0;
                    z <= 1;
                end
                else begin
                    z <= 0;
                end
            end
        endcase
    end
    
    initial begin
        state = S0;
        z = 1;
    end
endmodule