module TopModule (
    input        clk,
    input        reset,
    input        in,
    output       done
);

reg [7:0] data; // Collected data bits
reg [3:0] counter; // Counter for data bits and stop bit
reg done_reg; // Registered output

always @(posedge clk) begin
    if (reset) begin 
        counter <= 0;
        data <= 8'b0;
        done_reg <= 1'b0;
    end else begin
        case (counter)
            4'd0: if (!in) counter <= 4'd1; // Start bit detected
            4'd1: begin 
                data <= {data[6:0], in}; 
                counter <= counter + 1;
            end
            4'd9: if (in) begin // Stop bit detected
                    done_reg <= 1'b1; 
                    counter <= 4'd0; 
                end else begin
                    counter <= 4'd0; // Invalid stop bit, restart
                end
            default: begin 
                if (counter < 4'd9) begin
                    data <= {data[6:0], in}; 
                    counter <= counter + 1;
                end else begin
                    counter <= 4'd0; // If counter exceeds 9, reset it
                end
            end
        endcase
    end
end

assign done = done_reg;

endmodule