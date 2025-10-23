module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Current state register
    reg [255:0] current_state;

    // Function to get north neighbor index with wrapping
    function integer get_north;
        input integer idx;
        begin
            get_north = ((idx/16 + 15) % 16) * 16 + (idx % 16);
        end
    endfunction

    // Function to get south neighbor index with wrapping
    function integer get_south;
        input integer idx;
        begin
            get_south = ((idx/16 + 1) % 16) * 16 + (idx % 16);
        end
    endfunction

    // Function to get west neighbor index with wrapping
    function integer get_west;
        input integer idx;
        begin
            get_west = (idx/16)*16 + ((idx % 16 + 15) % 16;
        end
    endfunction

    // Function to get east neighbor index with wrapping
    function integer get_east;
        input integer idx;
        begin
            get_east = (idx/16)*16 + ((idx % 16 + 1) % 16;
        end
    endfunction

    // Next state calculation
    wire [255:0] next_state;
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : cell_update
            // Calculate neighbor counts
            wire [3:0] neighbor_count;
            assign neighbor_count = 
                current_state[get_north(i)] +    // N
                current_state[get_south(i)] +    // S
                current_state[get_west(i)] +      // W
                current_state[get_east(i)] +      // E
                current_state[get_north(get_west(i))] +  // NW
                current_state[get_north(get_east(i))] +  // NE
                current_state[get_south(get_west(i))] +  // SW
                current_state[get_south(get_east(i))];   // SE

            // Update rule
            assign next_state[i] = (neighbor_count == 2) ? current_state[i] :
                                  (neighbor_count == 3) ? 1'b1 :
                                  1'b0;
        end
    endgenerate

    // State update
    always @(posedge clk) begin
        if (load) begin
            current_state <= data;
        end else begin
            current_state <= next_state;
        end
    end

    // Output assignment
    always @(*) begin
        q = current_state;
    end

endmodule