module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output  logic   done
);

logic [1:0] counter;

always_ff @(posedge clk) begin
    if(reset) begin
        counter <= 0;
        done <= 0;
    end else begin
        if (in[3]) begin // Reset counter when start byte is detected
            counter <= 1;
        end else if (counter > 0 && counter < 3) begin // Increment counter for subsequent bytes
            counter <= counter + 1;
        end
        if (counter == 2) begin // Assert done when three bytes are received
            done <= 1;
        end else begin
            done <= 0;
        end
    end
end

endmodule