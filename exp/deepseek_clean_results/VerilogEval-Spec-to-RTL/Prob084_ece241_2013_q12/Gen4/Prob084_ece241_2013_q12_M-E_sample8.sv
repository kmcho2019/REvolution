module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    // Dual 4-bit shift registers
    reg [3:0] upper_reg;
    reg [3:0] lower_reg;
    
    // Lookahead address register
    reg [2:0] addr_reg;
    
    // Shift register logic
    always @(posedge clk) begin
        if (enable) begin
            // Cascade bits between upper and lower
            lower_reg <= {upper_reg[0], lower_reg[3:1]};
            upper_reg <= {S, upper_reg[3:1]};
        end
    end
    
    // Address pipeline register
    always @(posedge clk) begin
        addr_reg <= {A, B, C};
    end
    
    // Hierarchical mux implementation
    wire [3:0] selected_half = addr_reg[2] ? upper_reg : lower_reg;
    assign Z = selected_half[addr_reg[1:0]];
endmodule