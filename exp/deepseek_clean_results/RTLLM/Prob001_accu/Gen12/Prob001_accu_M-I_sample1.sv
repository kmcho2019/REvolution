module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [3:0] count;        // One-hot encoded counter (0001, 0010, 0100, 1000)
    reg [8:0] accumulator;  // Reduced to 9-bit accumulator
    reg [7:0] data_reg;     // Pipeline register for data_in
    reg valid_reg;          // Pipeline register for valid_in

    // Clock gating control
    wire accu_en = valid_in && (count != 4'b1000);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            count <= 4'b0001;
            accumulator <= 9'b0;
            data_reg <= 8'b0;
            valid_reg <= 1'b0;
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end
        else begin
            // Pipeline stage 1
            data_reg <= data_in;
            valid_reg <= valid_in;
            
            // Pipeline stage 2 (accumulator update)
            if (accu_en) begin
                accumulator <= accumulator + data_reg;
            end
            else if (count == 4'b1000) begin
                accumulator <= 9'b0;  // Reset after 4th input
            end

            // Counter logic
            if (valid_reg) begin
                count <= {count[2:0], count[3]};
            end

            // Output logic
            valid_out <= (count == 4'b1000) && valid_reg;
            if ((count == 4'b1000) && valid_reg) begin
                // Final sum with overflow detection
                data_out <= {1'b0, accumulator} + {2'b00, data_reg};
            end
        end
    end

endmodule