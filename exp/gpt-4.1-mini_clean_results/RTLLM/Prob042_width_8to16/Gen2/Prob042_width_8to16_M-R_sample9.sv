module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg [7:0]  data_lock;        // Stores first 8-bit data
    reg        have_first;       // Flag: 1 if first data stored, 0 otherwise

    reg [15:0] output_reg;       // Holds concatenated 16-bit output
    reg        output_valid_reg; // Registered valid signal for output stage

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock        <= 8'b0;
            have_first       <= 1'b0;
            output_reg       <= 16'b0;
            output_valid_reg <= 1'b0;
            data_out         <= 16'b0;
            valid_out        <= 1'b0;
        end else begin
            valid_out <= output_valid_reg;
            data_out  <= output_reg;

            output_valid_reg <= 1'b0; // Default deassert; set below if needed

            if (valid_in) begin
                if (!have_first) begin
                    // Capture first data byte
                    data_lock  <= data_in;
                    have_first <= 1'b1;
                end else begin
                    // Second data byte arrived, form 16-bit output next cycle
                    output_reg       <= {data_lock, data_in};
                    output_valid_reg <= 1'b1;
                    have_first       <= 1'b0;
                end
            end
        end
    end

endmodule