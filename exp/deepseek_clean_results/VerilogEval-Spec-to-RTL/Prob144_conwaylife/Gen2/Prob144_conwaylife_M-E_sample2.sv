module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Shift registers for neighbor detection
    wire [255:0] north, south, east, west;
    wire [255:0] ne, nw, se, sw;
    reg [255:0] next_q;

    // Generate shifted versions for neighbor detection
    // North shift (row - 1)
    assign north = {q[239:0], q[255:240]};
    // South shift (row + 1)
    assign south = {q[15:0], q[255:16]};
    // East shift (col + 1)
    assign east = {q[254:240], q[255], q[246:0], q[247]};
    // West shift (col - 1)
    assign west = {q[247:240], q[255:248], q[239:0]};

    // Diagonal shifts
    assign ne = {north[254:240], north[255], north[246:0], north[247]};
    assign nw = {north[247:240], north[255:248], north[239:0]};
    assign se = {south[254:240], south[255], south[246:0], south[247]};
    assign sw = {south[247:240], south[255:248], south[239:0]};

    // Neighbor count logic
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : cell_rules
            wire [7:0] neighbors = {
                ne[i], north[i], nw[i],
                east[i],          west[i],
                se[i], south[i], sw[i]
            };
            wire [3:0] neighbor_count = 
                neighbors[0] + neighbors[1] + neighbors[2] + neighbors[3] +
                neighbors[4] + neighbors[5] + neighbors[6] + neighbors[7];

            // Apply game rules
            always @(*) begin
                case (neighbor_count)
                    0, 1: next_q[i] = 1'b0;
                    2:    next_q[i] = q[i];
                    3:    next_q[i] = 1'b1;
                    default: next_q[i] = 1'b0;
                endcase
            end
        end
    endgenerate

    // Clocked update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule