module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [1:0] count;         // Counter for valid inputs (0-3)
    reg valid_in_reg;        // Registered version of valid_in
    wire [9:0] next_accum;   // Next accumulator value

    // Compute next accumulator value
    assign next_accum = data_out + data_in;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            count <= 2'b00;
            data_out <= 10'b0;
            valid_out <= 1'b0;
            valid_in_reg <= 1'b0;
        end else begin
            // Register valid_in to reduce glitches
            valid_in_reg <= valid_in;
            
            // Default outputs
            valid_out <= 1'b0;

            if (valid_in_reg) begin
                if (count == 2'b11) begin
                    // Output accumulated result
                    data_out <= next_accum;
                    valid_out <= 1'b1;
                    count <= 2'b00;
                end else begin
                    // Accumulate input data
                    data_out <= next_accum;
                    count <= count + 1;
                end
            end
        end
    end

endmodule