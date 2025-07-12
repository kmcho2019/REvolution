module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [1:0] counter;  // Tracks 0-3 counts
    reg [9:0] acc;      // Accumulation register
    
    // Counter update logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 2'b0;
        end else if (valid_in) begin
            counter <= (counter == 2'b11) ? 2'b0 : counter + 1;
        end
    end

    // Accumulation logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            acc <= 10'b0;
        end else if (valid_in) begin
            acc <= (counter == 2'b0) ? data_in : acc + data_in;
        end
    end

    // Output logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end else begin
            valid_out <= (counter == 2'b11) & valid_in;
            if (counter == 2'b11 & valid_in) begin
                data_out <= acc + data_in;
            end
        end
    end

endmodule