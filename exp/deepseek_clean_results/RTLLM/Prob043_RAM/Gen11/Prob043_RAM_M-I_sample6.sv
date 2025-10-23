module RAM (
    input clk,
    input rst_n,
    input write_en,
    input [2:0] write_addr,
    input [5:0] write_data,
    input read_en,
    input [2:0] read_addr,
    output reg [5:0] read_data
);

    parameter WIDTH = 6;
    parameter DEPTH = 8;
    
    // Memory array declaration
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Write operation (synchronous with separate reset)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset only the written address to avoid long critical path
            mem[write_addr] <= {WIDTH{1'b0}};
        end
        else if (write_en) begin
            mem[write_addr] <= write_data;
        end
    end
    
    // Read operation (registered output for better timing)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            read_data <= {WIDTH{1'b0}};
        end
        else if (read_en) begin
            read_data <= mem[read_addr];
        end
        // Maintain previous value when read_en is low (power optimization)
    end

    /* Optional clock gating for power optimization
    wire gated_clk;
    assign gated_clk = clk & (write_en | !rst_n);
    always @(posedge gated_clk or negedge rst_n) begin
        if (!rst_n) begin
            mem[write_addr] <= {WIDTH{1'b0}};
        end
        else begin
            mem[write_addr] <= write_data;
        end
    end
    */

endmodule