module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] w_count; // 2-bit signal to track w occurrences
reg [1:0] window_counter; // 2-bit counter for three clock cycles
reg in_window; // Flag to indicate if we are in the counting window

// Sequential logic
always @(posedge clk or posedge reset) begin
    if(reset) begin
        in_window <= 1'b0; // Reset: Not in window
        window_counter <= 2'b00;
        w_count <= 2'b00;
        z <= 1'b0;
    end else begin
        if(in_window) begin
            if(window_counter == 2'b11) begin
                // End of window, set z based on w_count
                z <= (w_count == 2'b10) ? 1'b1 : 1'b0;
                in_window <= 1'b1; // Stay in window for continuous checking
                window_counter <= 2'b00;
                w_count <= 2'b00;
            end else begin
                window_counter <= window_counter + 1'b1;
                if(w) begin
                    w_count <= w_count + 1'b1;
                end
            end
        end else begin
            if(s) begin
                in_window <= 1'b1; // Start window
                window_counter <= 2'b01;
                w_count <= 2'b00;
            end
        end
    end
end

endmodule