module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

// Temporary register to store the next state
reg [255:0] next_q;

// Function to count the number of alive neighbours for a cell
function [3:0] count_neighbours;
    input [3:0] x;
    input [3:0] y;
    reg [3:0] count;
    reg [255:0] temp_q;

    assign temp_q = q;

    count = 0;
    for (int i = -1; i <= 1; i++) begin
        for (int j = -1; j <= 1; j++) begin
            if (i != 0 || j != 0) begin
                if (temp_q[((x + i) % 16) * 16 + ((y + j) % 16)]) begin
                    count = count + 1;
                end
            end
        end
    end
    count_neighbours = count;
endfunction

// Update the next state
always @(*) begin
    if (load) begin
        next_q = data;
    end else begin
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                reg [3:0] x;
                reg [3:0] y;
                reg [3:0] neighbours;
                assign x = i;
                assign y = j;
                assign neighbours = count_neighbours(x, y);
                case (neighbours)
                    0, 1: next_q[i * 16 + j] = 0;
                    2: next_q[i * 16 + j] = q[i * 16 + j];
                    3: next_q[i * 16 + j] = 1;
                    default: next_q[i * 16 + j] = 0;
                endcase
            end
        end
    end
end

// Update the current state at the positive edge of the clock
always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= next_q;
    end
end

endmodule