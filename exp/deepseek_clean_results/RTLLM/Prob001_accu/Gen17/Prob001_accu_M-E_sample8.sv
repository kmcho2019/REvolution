module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

    // Shift register for last 4 inputs
    reg [7:0] data_buffer [0:3];
    reg [1:0] count;

    // Combinational sum of all buffer elements
    wire [9:0] sum = {2'b0, data_buffer[0]} + 
                     {2'b0, data_buffer[1]} + 
                     {2'b0, data_buffer[2]} + 
                     {2'b0, data_buffer[3]};

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            data_buffer[0] <= 8'b0;
            data_buffer[1] <= 8'b0;
            data_buffer[2] <= 8'b0;
            data_buffer[3] <= 8'b0;
            count <= 2'b0;
            valid_out <= 1'b0;
            data_out <= 10'b0;
        end else begin
            valid_out <= 1'b0;  // Default to 0 unless we complete accumulation
            
            if (valid_in) begin
                // Shift new data into buffer
                data_buffer[3] <= data_buffer[2];
                data_buffer[2] <= data_buffer[1];
                data_buffer[1] <= data_buffer[0];
                data_buffer[0] <= data_in;
                
                // Update counter
                if (count == 2'd3) begin
                    count <= 2'd0;
                    data_out <= sum;
                    valid_out <= 1'b1;
                end else begin
                    count <= count + 1;
                end
            end
        end
    end

endmodule