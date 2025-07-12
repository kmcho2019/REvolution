module width_8to16 (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        valid_in,
    input  wire [7:0]  data_in,
    output reg         valid_out,
    output reg  [15:0] data_out
);

    reg [7:0] first_data;
    reg       has_first_data;

    reg [15:0] next_data_out;
    reg        next_valid_out;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            first_data      <= 8'd0;
            has_first_data  <= 1'b0;
            data_out       <= 16'd0;
            valid_out      <= 1'b0;
        end else begin
            // Default outputs deasserted, updated below if needed
            valid_out <= next_valid_out;
            data_out  <= next_data_out;

            next_valid_out <= 1'b0;  // Default, set to 1 when output ready

            if (valid_in) begin
                if (!has_first_data) begin
                    // Store first 8-bit data
                    first_data     <= data_in;
                    has_first_data <= 1'b1;
                end else begin
                    // Second valid data arrived, prepare output for next cycle
                    next_data_out  <= {first_data, data_in};
                    next_valid_out <= 1'b1;
                    has_first_data <= 1'b0;  // Clear for next pair
                end
            end
        end
    end

endmodule