module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

// Data accumulation register
reg [15:0] data_accum;
reg valid_delay;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_accum <= 16'b0;
        valid_delay <= 1'b0;
        data_out <= 16'b0;
        valid_out <= 1'b0;
    end else begin
        // Shift register operation
        if (valid_in) begin
            data_accum <= {data_accum[7:0], data_in};
        end

        // Valid signal pipeline
        valid_delay <= valid_in;

        // Output generation (when we have two consecutive valids)
        valid_out <= valid_delay & valid_in;
        if (valid_delay & valid_in) begin
            data_out <= {data_accum[7:0], data_in};
        end
    end
end

endmodule