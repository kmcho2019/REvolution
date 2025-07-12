module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [1:0] count;
    reg [9:0] accumulator, next_accumulator;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'b0;
            accumulator <= 10'b0;
            data_out <= 10'b0;
            valid_out <= 1'b0;
        end else begin
            valid_out <= 1'b0;
            
            if (valid_in) begin
                accumulator <= next_accumulator;
                
                if (&count) begin  // Equivalent to count == 2'b11 but more efficient
                    data_out <= next_accumulator;
                    valid_out <= 1'b1;
                    count <= 2'b0;
                end else begin
                    count <= count + 1'b1;
                end
            end
        end
    end

    // Combinational logic for next accumulator value
    always @(*) begin
        if (!rst_n) begin
            next_accumulator = 10'b0;
        end else begin
            if (valid_in) begin
                if (&count) begin
                    next_accumulator = data_in;  // Start new accumulation
                end else begin
                    next_accumulator = accumulator + data_in;
                end
            end else begin
                next_accumulator = accumulator;
            end
        end
    end

endmodule