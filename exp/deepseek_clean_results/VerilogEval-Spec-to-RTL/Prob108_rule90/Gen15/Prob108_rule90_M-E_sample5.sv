module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

parameter WIDTH = 512;
reg [511:0] next_q;
reg [8:0] counter;  // 9 bits for 0-511
reg busy;
wire [2:0] window;

// 3-bit window: [left, center, right]
assign window[0] = (counter == 0) ? 1'b0 : q[counter-1];  // left neighbor
assign window[1] = q[counter];                            // current cell
assign window[2] = (counter == WIDTH-1) ? 1'b0 : q[counter+1];  // right neighbor

// FSM for serial processing
always @(posedge clk) begin
    if (load) begin
        q <= data;
        busy <= 1'b0;
        counter <= 0;
    end else begin
        if (!busy) begin
            // Start new computation cycle
            busy <= 1'b1;
            counter <= 0;
            next_q <= q;  // Initialize next state
        end else begin
            // Compute next state for current position
            next_q[counter] <= window[0] ^ window[2];
            
            // Move to next position or finish
            if (counter == WIDTH-1) begin
                busy <= 1'b0;
                q <= next_q;
            end else begin
                counter <= counter + 1;
            end
        end
    end
end

endmodule