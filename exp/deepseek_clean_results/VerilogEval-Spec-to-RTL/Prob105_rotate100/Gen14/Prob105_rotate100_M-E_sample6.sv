module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

// Segment the 100-bit register into 10 segments of 10 bits each
reg [9:0] segments [0:9];
integer i;

always @(posedge clk) begin
    if (load) begin
        // Load operation - split into segments
        for (i = 0; i < 10; i = i + 1) begin
            segments[i] <= data[i*10 +: 10];
        end
    end else begin
        case (ena)
            2'b01: begin // Right rotate
                // First rotate within each segment
                for (i = 0; i < 10; i = i + 1) begin
                    segments[i] <= {segments[i][0], segments[i][9:1]};
                end
                // Then rotate the segments (with carry)
                segments[0] <= {segments[9][0], segments[0][9:1]};
                for (i = 1; i < 10; i = i + 1) begin
                    segments[i] <= {segments[i-1][0], segments[i][9:1]};
                end
            end
            2'b10: begin // Left rotate
                // First rotate within each segment
                for (i = 0; i < 10; i = i + 1) begin
                    segments[i] <= {segments[i][8:0], segments[i][9]};
                end
                // Then rotate the segments (with carry)
                segments[9] <= {segments[9][8:0], segments[0][9]};
                for (i = 0; i < 9; i = i + 1) begin
                    segments[i] <= {segments[i][8:0], segments[i+1][9]};
                end
            end
            // default: no change
        endcase
    end
end

// Reconstruct the output from segments
always @(*) begin
    for (i = 0; i < 10; i = i + 1) begin
        q[i*10 +: 10] = segments[i];
    end
end

endmodule