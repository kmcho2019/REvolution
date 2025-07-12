module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // State machine to control neighbor counting phases
    reg [3:0] phase;
    always @(posedge clk) begin
        if (load) phase <= 0;
        else phase <= (phase == 8) ? 0 : phase + 1;
    end

    // Neighbor count accumulators
    reg [3:0] neighbor_count [0:255];
    
    // Current cell states (registered)
    reg [255:0] current_state;
    
    // Shift registers for neighbor propagation
    reg [255:0] north_buf, south_buf, east_buf, west_buf;
    reg [255:0] ne_buf, nw_buf, se_buf, sw_buf;
    
    // Next state calculation
    wire [255:0] next_state;
    
    integer i;
    always @(posedge clk) begin
        if (load) begin
            current_state <= data;
            for (i = 0; i < 256; i = i + 1)
                neighbor_count[i] <= 0;
        end
        else if (phase == 8) begin
            // Update all states simultaneously
            current_state <= next_state;
            // Reset neighbor counts
            for (i = 0; i < 256; i = i + 1)
                neighbor_count[i] <= 0;
        end
        else begin
            // Accumulate neighbor counts based on phase
            case (phase)
                0: begin // North
                    for (i = 0; i < 256; i = i + 1) begin
                        neighbor_count[i] <= neighbor_count[i] + north_buf[i];
                        north_buf[i] <= current_state[(i+240)%256]; // Wrap around for row 0
                    end
                end
                1: begin // South
                    for (i = 0; i < 256; i = i + 1) begin
                        neighbor_count[i] <= neighbor_count[i] + south_buf[i];
                        south_buf[i] <= current_state[(i+16)%256]; // Wrap around for row 15
                    end
                end
                2: begin // East
                    for (i = 0; i < 256; i = i + 1) begin
                        neighbor_count[i] <= neighbor_count[i] + east_buf[i];
                        east_buf[i] <= current_state[((i/16)*16) + ((i%16)+1)%16]; // Wrap around column 15
                    end
                end
                3: begin // West
                    for (i = 0; i < 256; i = i + 1) begin
                        neighbor_count[i] <= neighbor_count[i] + west_buf[i];
                        west_buf[i] <= current_state[((i/16)*16) + ((i%16)+15)%16]; // Wrap around column 0
                    end
                end
                4: begin // NE
                    for (i = 0; i < 256; i = i + 1) begin
                        neighbor_count[i] <= neighbor_count[i] + ne_buf[i];
                        ne_buf[i] <= current_state[((((i/16)+15)%16)*16) + ((i%16)+1)%16];
                    end
                end
                5: begin // NW
                    for (i = 0; i < 256; i = i + 1) begin
                        neighbor_count[i] <= neighbor_count[i] + nw_buf[i];
                        nw_buf[i] <= current_state[((((i/16)+15)%16)*16) + ((i%16)+15)%16];
                    end
                end
                6: begin // SE
                    for (i = 0; i < 256; i = i + 1) begin
                        neighbor_count[i] <= neighbor_count[i] + se_buf[i];
                        se_buf[i] <= current_state[((((i/16)+1)%16)*16) + ((i%16)+1)%16];
                    end
                end
                7: begin // SW
                    for (i = 0; i < 256; i = i + 1) begin
                        neighbor_count[i] <= neighbor_count[i] + sw_buf[i];
                        sw_buf[i] <= current_state[((((i/16)+1)%16)*16) + ((i%16)+15)%16];
                    end
                end
            endcase
        end
    end

    // Next state calculation (combinational)
    generate
        for (i = 0; i < 256; i = i + 1) begin : state_update
            assign next_state[i] = (neighbor_count[i] == 2) ? current_state[i] :
                                  (neighbor_count[i] == 3) ? 1'b1 :
                                  1'b0;
        end
    endgenerate

    // Output assignment
    always @(*) begin
        q = current_state;
    end

endmodule