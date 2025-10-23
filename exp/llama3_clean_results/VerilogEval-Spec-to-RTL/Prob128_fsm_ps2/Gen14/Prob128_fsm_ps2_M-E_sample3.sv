module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

logic [1:0] counter;

always_ff @(posedge clk) begin
    if(reset) begin
        counter <= 2'd0;
        done <= 0;
    end else begin
        if (in[3]) begin
            counter <= 2'd1; // Reset counter when message boundary is detected
        end else if (counter != 2'd0) begin
            counter <= counter + 1'd1; // Increment counter for subsequent bytes
        end
        
        if (counter == 2'd3) begin
            done <= 1; // Signal done when a complete message is received
            counter <= 2'd0; // Reset counter to start searching for the next message boundary
        end else begin
            done <= 0;
        end
    end
end

endmodule