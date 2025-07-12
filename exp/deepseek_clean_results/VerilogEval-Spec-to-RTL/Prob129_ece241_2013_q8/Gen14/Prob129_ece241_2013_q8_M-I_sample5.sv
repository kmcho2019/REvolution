module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    reg [1:0] x_history;
    reg x_sync;

    // Input synchronization for metastability protection
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            x_sync <= 1'b0;
        end else begin
            x_sync <= x;
        end
    end

    // Clock-gated shift register
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            x_history <= 2'b00;
        end else if (x_history[0] != x_sync) begin // Only update when input changes
            x_history <= {x_history[0], x_sync};
        end
    end

    // Simplified output logic
    assign z = (x_history == 2'b10) & x_sync;

endmodule