module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Segment the counter into 4-bit chunks
wire [3:0] count_seg0 = count[3:0];
wire [3:0] count_seg1 = count[7:4];
wire [3:0] count_seg2 = count[11:8];
wire [3:0] count_seg3 = count[15:12];

// Generate next values for each segment with carry lookahead
wire [3:0] next_seg0;
wire [3:0] next_seg1;
wire [3:0] next_seg2;
wire [3:0] next_seg3;
wire carry0, carry1, carry2;

// Segment 0 (LSB)
assign {carry0, next_seg0} = up_down ? 
    ({1'b0, count_seg0} + 5'b00001) : 
    ({1'b0, count_seg0} + 5'b11111); // 2's complement -1

// Segment 1
assign {carry1, next_seg1} = up_down ? 
    ({1'b0, count_seg1} + {4'b0, carry0}) : 
    ({1'b0, count_seg1} + {4'b0, ~carry0});

// Segment 2
assign {carry2, next_seg2} = up_down ? 
    ({1'b0, count_seg2} + {4'b0, carry1}) : 
    ({1'b0, count_seg2} + {4'b0, ~carry1});

// Segment 3 (MSB)
assign next_seg3 = up_down ? 
    (count_seg3 + {3'b0, carry2}) : 
    (count_seg3 + {3'b0, ~carry2});

// Sequential update
always @(posedge clk) begin
    if (reset) begin
        count <= 16'b0;
    end else begin
        count <= {next_seg3, next_seg2, next_seg1, next_seg0};
    end
end

endmodule