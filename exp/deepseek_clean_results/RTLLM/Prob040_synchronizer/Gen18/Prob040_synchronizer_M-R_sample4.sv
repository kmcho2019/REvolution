module synchronizer #(
    parameter WIDTH = 4
) (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [WIDTH-1:0] data_in,
    input wire data_en,
    output reg [WIDTH-1:0] dataout
);

    // Clock domain A registers
    reg [WIDTH-1:0] data_reg;
    reg en_reg_a;
    
    // Clock domain B synchronization registers
    reg en_sync1, en_sync2;
    
    // Data capture in clk_a domain
    assign data_reg = (!arstn) ? {WIDTH{1'b0}} : 
                     (data_en) ? data_in : data_reg;
    
    // Enable capture in clk_a domain
    assign en_reg_a = (!arstn) ? 1'b0 : data_en;
    
    // First stage synchronization (clk_b domain)
    assign en_sync1 = (!brstn) ? 1'b0 : en_reg_a;
    
    // Second stage synchronization (clk_b domain)
    assign en_sync2 = (!brstn) ? 1'b0 : en_sync1;
    
    // Output assignment (clk_b domain)
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= {WIDTH{1'b0}};
        end else if (en_sync2) begin
            dataout <= data_reg;
        end
    end

endmodule