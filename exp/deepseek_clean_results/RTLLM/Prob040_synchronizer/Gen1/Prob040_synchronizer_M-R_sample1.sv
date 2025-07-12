module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout
);

    // Parameters for design flexibility
    parameter DATA_WIDTH = 4;
    
    // Clock domain A registers
    reg [DATA_WIDTH-1:0] data_reg;
    reg en_a_reg;
    
    // Clock domain B signals
    wire en_b_sync;
    wire [DATA_WIDTH-1:0] data_out_next;
    
    //=========================================
    // Clock Domain A Logic
    //=========================================
    // Data capture register
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= {DATA_WIDTH{1'b0}};
        end else begin
            data_reg <= data_in;
        end
    end
    
    // Enable capture register
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            en_a_reg <= 1'b0;
        end else begin
            en_a_reg <= data_en;
        end
    end
    
    //=========================================
    // Clock Domain Crossing Synchronizer
    //=========================================
    sync_2ff #(.WIDTH(1)) enable_sync (
        .clk(clk_b),
        .rstn(brstn),
        .d(en_a_reg),
        .q(en_b_sync)
    );
    
    //=========================================
    // Clock Domain B Logic
    //=========================================
    // Next data value computation (combinational)
    assign data_out_next = en_b_sync ? data_reg : dataout;
    
    // Output register
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            dataout <= {DATA_WIDTH{1'b0}};
        end else begin
            dataout <= data_out_next;
        end
    end

endmodule

// 2-flip-flop synchronizer module
module sync_2ff #(
    parameter WIDTH = 1
)(
    input wire clk,
    input wire rstn,
    input wire [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);
    reg [WIDTH-1:0] sync_reg;
    
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            sync_reg <= {WIDTH{1'b0}};
            q <= {WIDTH{1'b0}};
        end else begin
            sync_reg <= d;
            q <= sync_reg;
        end
    end
endmodule