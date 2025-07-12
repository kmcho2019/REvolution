module width_8to16 (
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output reg      valid_out,
    output reg [15:0] data_out
);

    reg [7:0]  data_lock;       // Holds first 8-bit data
    reg        flag;            // Indicates if first data is stored (1) or not (0)

    reg [15:0] data_out_reg;    // Pipeline register for output data (concatenated)
    reg        valid_out_reg;   // Pipeline register for output valid

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_lock     <= 8'd0;
            flag          <= 1'b0;
            data_out_reg  <= 16'd0;
            valid_out_reg <= 1'b0;
            valid_out     <= 1'b0;
            data_out      <= 16'd0;
        end else begin
            // Default: clear valid_out_reg only when output valid_out has been sent out
            // valid_out_reg serves as the "pulse" generator for valid_out
            // valid_out_reg stays 1 in the clock cycle it's generated, and cleared next
            if (valid_out_reg)
                valid_out_reg <= 1'b0;

            if (valid_in) begin
                if (flag == 1'b0) begin
                    // Store first 8-bit input
                    data_lock <= data_in;
                    flag <= 1'b1;
                end else begin
                    // Second valid input arrived, concatenate and prepare output next cycle
                    data_out_reg  <= {data_lock, data_in};
                    valid_out_reg <= 1'b1;
                    flag <= 1'b0;
                end
            end

            // Assign outputs from pipeline registers after update
            valid_out <= valid_out_reg;
            data_out  <= data_out_reg;
        end
    end

endmodule