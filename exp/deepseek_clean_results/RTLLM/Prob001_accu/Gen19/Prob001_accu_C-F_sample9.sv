module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    reg [1:0] count;        // Binary counter (0-3)
    reg [9:0] accumulator;  // Shared accumulator/output register
    wire [9:0] next_accum;
    wire final_cycle;

    // Combinational logic
    assign next_accum = valid_in ? accumulator + data_in : accumulator;
    assign final_cycle = (count == 2'b11) & valid_in;

    // Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'b00;
            accumulator <= 10'b0;
            valid_out <= 1'b0;
            data_out <= 10'b0;
        end
        else begin
            // Default outputs
            valid_out <= 1'b0;
            
            if (valid_in) begin
                if (final_cycle) begin
                    // Output and reset on 4th valid input
                    data_out <= next_accum;
                    valid_out <= 1'b1;
                    accumulator <= 10'b0;
                    count <= 2'b00;
                end
                else begin
                    // Accumulate and count
                    accumulator <= next_accum;
                    count <= count + 1'b1;
                end
            end
        end
    end

endmodule