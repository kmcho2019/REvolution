module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Data capture in clk_a domain (combinational with reset)
    reg [3:0] data_reg;
    reg en_data_reg;
    
    assign data_reg = (!arstn) ? 4'b0 : data_in;
    assign en_data_reg = (!arstn) ? 1'b0 : data_en;

    // Two-stage synchronizer as shift register
    reg [1:0] en_sync;
    
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            en_sync <= 2'b00;
        end else begin
            en_sync <= {en_sync[0], en_data_reg};
        end
    end

    // Output data register with explicit mux
    wire [3:0] next_dataout = en_sync[1] ? data_reg : dataout;
    
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= 4'b0;
        end else begin
            dataout <= next_dataout;
        end
    end

endmodule