module TopModule (
    input clk,
    input load,
    input stall,
    input [511:0] data,
    output reg [511:0] q
);

    // Pipeline registers
    reg [255:0] first_stage;
    reg [255:0] second_stage;
    
    // Clock gating signals
    wire update_enable = ~stall;
    wire second_stage_clk = clk & update_enable;
    
    // First stage computation (bits 0-255)
    wire [255:0] first_stage_next;
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin: first_stage_gen
            wire left = (i == 0) ? 1'b0 : (i == 256) ? q[255] : data[i-1];
            wire right = (i == 255) ? q[256] : data[i+1];
            assign first_stage_next[i] = left ^ right;
        end
    endgenerate
    
    // Second stage computation (bits 256-511)
    wire [255:0] second_stage_next;
    generate
        for (i = 256; i < 512; i = i + 1) begin: second_stage_gen
            wire left = (i == 256) ? first_stage[255] : q[i-1];
            wire right = (i == 511) ? 1'b0 : q[i+1];
            assign second_stage_next[i-256] = left ^ right;
        end
    endgenerate
    
    // Pipeline control
    always @(posedge clk) begin
        if (load) begin
            q <= data;
            first_stage <= 256'b0;
            second_stage <= 256'b0;
        end else if (~stall) begin
            first_stage <= first_stage_next;
            q[255:0] <= first_stage;
        end
    end
    
    always @(posedge second_stage_clk) begin
        if (~load && ~stall) begin
            second_stage <= second_stage_next;
            q[511:256] <= second_stage;
        end
    end

endmodule