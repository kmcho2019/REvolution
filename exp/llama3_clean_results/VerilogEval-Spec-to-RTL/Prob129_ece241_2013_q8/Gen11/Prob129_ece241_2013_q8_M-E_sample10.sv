module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] count; // Counter to track the sequence progress

// Asynchronous reset
always @(negedge aresetn or posedge clk) begin
    if (!aresetn) begin
        count <= 2'b00;
    end else begin
        case (count)
            2'b00: begin
                if (x == 1'b1) begin
                    count <= 2'b01; // Correct first bit, move to next state
                end else begin
                    count <= 2'b00; // Incorrect first bit, stay in initial state
                end
            end
            2'b01: begin
                if (x == 1'b0) begin
                    count <= 2'b10; // Correct second bit, move to next state
                end else begin
                    count <= 2'b00; // Incorrect second bit, reset to initial state
                end
            end
            2'b10: begin
                if (x == 1'b1) begin
                    count <= 2'b10; // Correct third bit, stay in final state
                end else begin
                    count <= 2'b00; // Incorrect third bit, reset to initial state
                end
            end
            default: count <= 2'b00;
        endcase
    end
end

// Assert output z when the entire sequence is recognized
assign z = (count == 2'b10);

endmodule