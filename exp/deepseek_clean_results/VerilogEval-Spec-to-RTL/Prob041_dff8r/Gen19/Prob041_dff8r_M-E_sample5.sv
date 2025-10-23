module TopModule #(
    parameter WIDTH = 8,
    parameter RESET_VAL = 8'h00,  // Configurable reset value
    parameter USE_OUTPUT_REG = 1   // 1=enable output reg, 0=disable
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output [WIDTH-1:0] q,
    input load_en      // Parallel load enable
);

    // Metastability protection registers
    reg [WIDTH-1:0] sync_d_ff1, sync_d_ff2;
    reg sync_load_en_ff1, sync_load_en_ff2;
    
    // Main storage elements organized as circular buffer
    reg [WIDTH-1:0] data_ff [1:0];  // Two-stage for pointer rotation
    reg ptr;  // Rotation pointer
    
    // Output stage
    reg [WIDTH-1:0] out_reg;

    // Input synchronization
    always @(posedge clk) begin
        sync_d_ff1 <= d;
        sync_d_ff2 <= sync_d_ff1;
        sync_load_en_ff1 <= load_en;
        sync_load_en_ff2 <= sync_load_en_ff1;
    end

    // Circular buffer implementation with rotating pointer
    always @(posedge clk) begin
        if (reset) begin
            data_ff[0] <= RESET_VAL;
            data_ff[1] <= RESET_VAL;
            ptr <= 1'b0;
        end else begin
            if (sync_load_en_ff2) begin
                // Parallel load operation
                data_ff[ptr] <= sync_d_ff2;
                ptr <= ~ptr;  // Rotate pointer on load
            end else begin
                // Normal shift operation
                data_ff[ptr] <= data_ff[~ptr];
            end
        end
    end

    // Output logic
    generate
        if (USE_OUTPUT_REG) begin
            always @(posedge clk) begin
                if (reset) begin
                    out_reg <= RESET_VAL;
                end else begin
                    out_reg <= data_ff[~ptr];  // Always output from opposite side
                end
            end
            assign q = out_reg;
        end else begin
            assign q = data_ff[~ptr];
        end
    endgenerate

endmodule