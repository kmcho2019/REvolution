module ROM #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 16
)(
    input [ADDR_WIDTH-1:0] addr,
    output [DATA_WIDTH-1:0] dout
);

localparam MEM_SIZE = 2**ADDR_WIDTH;
localparam NUM_SUB_MODULES = 4; // Divide the memory into 4 sub-modules

reg [DATA_WIDTH-1:0] mem_sub_module [0:NUM_SUB_MODULES-1][0:MEM_SIZE/NUM_SUB_MODULES-1];

// Initialize the memory sub-modules
initial begin
    for (int i = 0; i < NUM_SUB_MODULES; i++) begin
        for (int j = 0; j < MEM_SIZE/NUM_SUB_MODULES; j++) begin
            if (i == 0 && j < 4) begin
                // Initialize the first sub-module with specific values
                case (j)
                    0: mem_sub_module[i][j] = 16'hA0A0;
                    1: mem_sub_module[i][j] = 16'hB1B1;
                    2: mem_sub_module[i][j] = 16'hC2C2;
                    3: mem_sub_module[i][j] = 16'hD3D3;
                    default: mem_sub_module[i][j] = 16'h0000;
                endcase
            end else begin
                mem_sub_module[i][j] = 16'h0000; // Default value for other locations
            end
        end
    end
end

// Generate the enable signals for each sub-module
wire [NUM_SUB_MODULES-1:0] enable;
always @(*) begin
    for (int i = 0; i < NUM_SUB_MODULES; i++) begin
        enable[i] = (addr[ADDR_WIDTH-1:ADDR_WIDTH-2] == i);
    end
end

// Output the data from the selected sub-module
reg [DATA_WIDTH-1:0] sub_module_out [0:NUM_SUB_MODULES-1];
always @(*) begin
    for (int i = 0; i < NUM_SUB_MODULES; i++) begin
        sub_module_out[i] = mem_sub_module[i][addr[ADDR_WIDTH-3:0]];
    end
end

// Use a multiplexer to select the output from the enabled sub-module
always @(*) begin
    case (enable)
        4'b0001: dout = sub_module_out[0];
        4'b0010: dout = sub_module_out[1];
        4'b0100: dout = sub_module_out[2];
        4'b1000: dout = sub_module_out[3];
        default: dout = 16'h0000;
    endcase
end

endmodule