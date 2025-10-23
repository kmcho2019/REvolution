module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [1:0] count;
    reg [9:0] accumulator;
    reg [9:0] next_accum;
    reg count_eq_3;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'b00;
            accumulator <= 10'b0;
            data_out <= 10'b0;
            valid_out <= 1'b0;
            count_eq_3 <= 1'b0;
        end
        else begin
            // Registered count comparison
            count_eq_3 <= (count == 2'b11);
            
            if (valid_in) begin
                // Update accumulator and count
                accumulator <= next_accum;
                count <= count + 1'b1;
                
                // Output generation
                if (count_eq_3) begin
                    data_out <= next_accum;
                    valid_out <= 1'b1;
                    count <= 2'b00;
                end
                else begin
                    valid_out <= 1'b0;
                end
            end
            else begin
                valid_out <= 1'b0;
            end
        end
    end

    // Combinational next accumulator value
    always @(*) begin
        next_accum = accumulator + data_in;
    end

endmodule