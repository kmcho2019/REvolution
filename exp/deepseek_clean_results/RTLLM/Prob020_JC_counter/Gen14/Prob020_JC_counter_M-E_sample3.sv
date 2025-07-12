module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// Internal signals for slice control
wire [7:0] slice_in [7:0];
wire [7:0] slice_out [7:0];

// Generate 8 slices of 8-bit Johnson counters
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : SLICE
        // Chain slices: next slice's input is current slice's LSB
        assign slice_in[i] = (i == 0) ? {~Q[7:0][0], Q[7:0][7:1]} :
                           {~slice_out[i-1][0], slice_out[i-1][7:1]};
        
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                slice_out[i] <= 8'b0;
            end else begin
                slice_out[i] <= slice_in[i];
            end
        end
        
        // Assign output bits
        assign Q[(i*8)+7:(i*8)] = slice_out[i];
    end
endgenerate

endmodule