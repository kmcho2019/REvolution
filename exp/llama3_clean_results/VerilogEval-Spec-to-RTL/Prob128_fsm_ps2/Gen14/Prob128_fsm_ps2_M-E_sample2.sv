module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

// 2-bit counter to keep track of the number of bytes received
logic [1:0] byte_counter;

// Flag to indicate if the current byte has in[3]=1
logic in3_flag;

// Combinational logic to reset the counter when in[3]=1
assign in3_flag = in[3];

// Counter logic
always_ff @(posedge clk) begin
    if(reset) begin
        byte_counter <= 2'd0;
        done <= 0;
    end else begin
        if(in3_flag) begin
            byte_counter <= 2'd1;  // Reset counter and start from 1
        end else if(byte_counter != 2'd3) begin
            byte_counter <= byte_counter + 1;  // Increment counter
        end else begin
            byte_counter <= 2'd0;  // Reset counter after reaching 3
        end
        // Assert 'done' when the counter reaches 3
        done <= (byte_counter == 2'd3);
    end
end

endmodule