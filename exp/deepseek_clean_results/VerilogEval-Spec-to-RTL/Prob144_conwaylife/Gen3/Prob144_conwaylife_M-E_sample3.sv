module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // State registers
    reg [255:0] current_state;
    
    // Shift registers for neighbor propagation
    reg [255:0] north_in, south_in, east_in, west_in;
    reg [255:0] north_out, south_out, east_out, west_out;
    
    // Neighbor counting pipeline registers
    reg [255:0] stage1, stage2, stage3;
    
    // Final next state
    wire [255:0] next_state;
    
    // Load or update state
    always @(posedge clk) begin
        if (load) begin
            current_state <= data;
        end else begin
            current_state <= next_state;
        end
    end
    
    // Toroidal shift operations
    always @(posedge clk) begin
        // North shift (row-wise up)
        north_out <= {current_state[15:0], current_state[255:16]};
        // South shift (row-wise down)
        south_out <= {current_state[239:0], current_state[255:240]};
        // East shift (column-wise right)
        for (integer i = 0; i < 16; i = i + 1) begin
            east_out[i*16 +: 16] <= {current_state[i*16], current_state[i*16 + 15:i*16 + 1]};
        end
        // West shift (column-wise left)
        for (integer i = 0; i < 16; i = i + 1) begin
            west_out[i*16 +: 16] <= {current_state[i*16 + 14:i*16], current_state[i*16 + 15]};
        end
    end
    
    // Pipeline stage 1: Capture immediate neighbors
    always @(posedge clk) begin
        stage1 <= north_out | south_out | east_out | west_out;
    end
    
    // Pipeline stage 2: Capture diagonal neighbors
    always @(posedge clk) begin
        // NE = north_out & east_out
        // NW = north_out & west_out
        // SE = south_out & east_out
        // SW = south_out & west_out
        stage2 <= (north_out & east_out) | (north_out & west_out) | 
                 (south_out & east_out) | (south_out & west_out);
    end
    
    // Pipeline stage 3: Count neighbors and compute next state
    always @(posedge clk) begin
        stage3 <= (stage1 & ~stage2) |  // Exactly 2 neighbors
                 (stage2 & ~stage1);    // Exactly 3 neighbors
    end
    
    // Final next state assignment
    assign next_state = load ? data : stage3;
    assign q = current_state;

endmodule