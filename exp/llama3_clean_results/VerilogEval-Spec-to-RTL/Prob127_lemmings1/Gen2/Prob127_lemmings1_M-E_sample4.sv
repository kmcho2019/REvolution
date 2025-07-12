module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

// Define the threshold for changing direction
parameter THRESHOLD = 1;

// Internal counter register
reg [1:0] counter;

// Output logic
always @(*) begin
    if (counter == 0) begin
        walk_left = 1'b1;
        walk_right = 1'b0;
    end else begin
        walk_left = 1'b0;
        walk_right = 1'b1;
    end
end

// Sequential logic
always @ (posedge clk or posedge areset) begin
    if (areset) begin
        counter <= 0;
    end else begin
        if (bump_left && bump_right) begin
            counter <= ~counter[0];
        end else if (bump_left) begin
            if (counter == 0) begin
                counter <= THRESHOLD;
            end else begin
                counter <= counter - 1;
            end
        end else if (bump_right) begin
            if (counter == THRESHOLD) begin
                counter <= 0;
            end else begin
                counter <= counter + 1;
            end
        end else begin
            counter <= counter;
        end
    end
end

endmodule