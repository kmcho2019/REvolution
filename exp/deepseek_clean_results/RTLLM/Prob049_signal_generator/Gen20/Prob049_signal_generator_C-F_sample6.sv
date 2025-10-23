module signal_generator (
    input clk,
    input rst_n,
    output reg [4:0] wave
);

reg [5:0] counter; // 6-bit counter for automatic direction change
reg direction;     // Explicit direction control (0=up, 1=down)

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 6'b0;
        direction <= 1'b0;
        wave <= 5'b0;
    end else begin
        // Update counter and detect overflow (natural direction change)
        counter <= counter + 1;
        if (counter == 6'b111111) begin
            direction <= ~direction;
        end
        
        // Generate triangle wave with registered output
        if (direction) begin
            wave <= ~counter[4:0]; // Decrement phase (mirror)
        end else begin
            wave <= counter[4:0];   // Increment phase
        end
    end
end

endmodule