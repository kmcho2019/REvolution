module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

    // Shift register buffers for neighbor access
    reg [255:0] current_grid;
    reg [255:0] prev_row;
    reg [255:0] next_row;
    
    // Temporary storage for neighbor counts
    reg [3:0] neighbor_count [0:255];
    
    // Shift operation to get wrapped rows
    always @(*) begin
        // Previous row (wrapped)
        prev_row = {q[15:0], q[255:16]};
        // Next row (wrapped)
        next_row = {q[239:0], q[255:240]};
    end
    
    // Calculate neighbor counts
    integer i;
    always @(*) begin
        for (i = 0; i < 256; i = i + 1) begin
            // Calculate column positions with wrap-around
            integer left_col = (i % 16 == 0) ? i + 15 : i - 1;
            integer right_col = (i % 16 == 15) ? i - 15 : i + 1;
            
            // Count neighbors from previous row
            reg [3:0] count = 0;
            count = count + prev_row[left_col] + prev_row[i] + prev_row[right_col];
            
            // Count neighbors from current row
            count = count + q[left_col] + q[right_col];
            
            // Count neighbors from next row
            count = count + next_row[left_col] + next_row[i] + next_row[right_col];
            
            neighbor_count[i] = count;
        end
    end
    
    // Calculate next state
    wire [255:0] next_q;
    generate
        for (genvar i = 0; i < 256; i = i + 1) begin : state_update
            assign next_q[i] = (neighbor_count[i] == 3) ? 1'b1 :
                              (neighbor_count[i] == 2) ? q[i] :
                              1'b0;
        end
    endgenerate
    
    // Update state
    always @(posedge clk) begin
        if (load) begin
            q <= data;
            current_grid <= data;
        end else begin
            q <= next_q;
            current_grid <= next_q;
        end
    end

endmodule