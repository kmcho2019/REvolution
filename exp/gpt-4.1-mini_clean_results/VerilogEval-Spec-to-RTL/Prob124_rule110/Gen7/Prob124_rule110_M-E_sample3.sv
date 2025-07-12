module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] bufferA, bufferB;
    reg buffer_sel; // 0: bufferA current state, 1: bufferB current state
    reg [8:0] index; // 0 to 511, for current cell being updated

    wire left, center, right;
    wire next_cell_state;

    // Select current and next buffers
    wire [511:0] current_buffer = (buffer_sel == 0) ? bufferA : bufferB;
    wire [511:0] next_buffer = (buffer_sel == 0) ? bufferB : bufferA;

    // Neighbor extraction with zero boundary condition
    assign left   = (index == 511) ? 1'b0 : current_buffer[index + 1];
    assign center = current_buffer[index];
    assign right  = (index == 0)   ? 1'b0 : current_buffer[index - 1];

    // Rule 110 logic: next = (~left & center) | (center ^ right)
    assign next_cell_state = (~left & center) | (center ^ right);

    always @(posedge clk) begin
        if (load) begin
            // Load new data into bufferA immediately
            bufferA <= data;
            bufferB <= 0;    // clear other buffer
            q <= data;
            buffer_sel <= 0;
            index <= 0;
        end else begin
            // Update next_buffer at position 'index' with next_cell_state
            if (buffer_sel == 0) begin
                bufferB <= next_buffer; // default hold old content
                bufferB[index] <= next_cell_state;
            end else begin
                bufferA <= next_buffer;
                bufferA[index] <= next_cell_state;
            end

            // Increment index and swap buffers after full update
            if (index == 511) begin
                index <= 0;
                buffer_sel <= ~buffer_sel;
                // Output the buffer just completed (the updated one)
                if (buffer_sel == 0)
                    q <= bufferB;
                else
                    q <= bufferA;
            end else begin
                index <= index + 1;
            end
        end
    end

endmodule