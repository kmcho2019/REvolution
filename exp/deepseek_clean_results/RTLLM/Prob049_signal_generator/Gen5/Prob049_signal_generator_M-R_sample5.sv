module signal_generator (
    input clk,
    input rst_n,
    output [4:0] wave
);

reg [4:0] counter;
reg direction;  // 0=up, 1=down

// Next counter value logic
wire [4:0] next_counter = direction ? counter - 1 : counter + 1;

// Direction toggle at boundaries
wire toggle_direction = (counter == 5'd0) || (counter == 5'd31);

// Sequential logic for counter and direction
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        counter <= 5'b0;
        direction <= 1'b0;
    end
    else begin
        counter <= next_counter;
        if (toggle_direction) begin
            direction <= ~direction;
        end
    end
end

// Combinational output assignment
assign wave = counter;

endmodule