module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] state;
    reg [8:0] cell_index;
    reg processing;
    reg left_neighbor, right_neighbor;

    // Output assignment
    assign q = state;

    always @(posedge clk) begin
        if (load) begin
            state <= data;
            cell_index <= 0;
            processing <= 0;
        end else begin
            if (!processing) begin
                // Start processing cycle
                processing <= 1;
                cell_index <= 0;
                // Initialize neighbors for first cell
                left_neighbor <= 0;          // q[-1] = 0
                right_neighbor <= state[0];  // q[0]
            end else begin
                // Process current cell
                state[cell_index] <= left_neighbor ^ right_neighbor;
                
                // Prepare neighbors for next cell
                if (cell_index == 511) begin
                    // Last cell - wrap around
                    left_neighbor <= state[511];
                    right_neighbor <= 0;     // q[512] = 0
                    processing <= 0;          // End processing cycle
                end else begin
                    left_neighbor <= state[cell_index];
                    right_neighbor <= (cell_index == 510) ? 0 : state[cell_index+2];
                end
                
                // Increment cell index
                cell_index <= cell_index + 1;
            end
        end
    end

endmodule