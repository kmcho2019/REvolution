module TopModule (
  input wire clk,
  input wire reset,
  input wire data,
  output reg [3:0] count,
  output reg counting,
  output reg done,
  input wire ack
);

typedef enum logic [1:0] {
    SEARCH,
    PATTERN,
	COUNTING,
	WAIT_ACK
} state_t;

reg [15:0] counter;
reg [3:0] delay;
reg [2:0] pattern;
reg [3:0] remaining_time;
state_t state;

always @ (posedge clk or posedge reset) begin
	if (reset) begin
		state <= SEARCH;
		counter <= 16'd0;
		delay <= 4'd0;
		counting <= 0;
		done <= 0;
		remaining_time <= 4'd0;
		pattern <= 3'd0;
	end
	else begin
		case(state)

			SEARCH: begin
				if (data == 1 && pattern == 3'd5) begin
					state <= PATTERN;
					delay <= data;
					pattern <= 3'd0;
				end
				else if (data == 1) begin
					pattern <= pattern + 1;
				end
				else begin
					pattern <= 3'd0;
				end
			end

			PATTERN: begin
				state <= COUNTING;
				counting <= 1;
				counter <= (delay + 1) * 1000;
				remaining_time <= delay;
			end

			COUNTING: begin
				if (counter > 0) begin
					counter <= counter - 1;
					if (counter == 0) begin
						counting <= 0;
						done <= 1;
						state <= WAIT_ACK;
					end
				end
			end

			WAIT_ACK: begin
				if (ack == 1) begin
					done <= 0;
					state <= SEARCH;
				end
			end
		endcase
	end
end

assign count = remaining_time;

endmodule