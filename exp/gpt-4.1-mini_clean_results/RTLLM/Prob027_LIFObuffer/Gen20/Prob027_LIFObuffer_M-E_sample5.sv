module LIFObuffer (
    input  wire        Clk,
    input  wire        Rst,      // Active-high synchronous reset
    input  wire        EN,       // Enable operations
    input  wire        RW,       // 0 = write (push), 1 = read (pop)
    input  wire [3:0]  dataIn,
    output wire        EMPTY,
    output wire        FULL,
    output reg  [3:0]  dataOut
);

    reg [3:0] stack_mem [3:0];  // 4x4-bit memory

    reg [1:0] ptr;   // points to next free position on push
    reg [2:0] count; // number of elements stored: 0..4 (3-bit to cover 0 to 4)

    // On reset, clear memory, pointer, count, and dataOut
    integer i;
    always @(posedge Clk) begin
        if (Rst) begin
            ptr <= 2'b00;
            count <= 3'b000;
            dataOut <= 4'b0000;
            for (i=0; i<4; i=i+1) begin
                stack_mem[i] <= 4'b0000;
            end
        end else if (EN) begin
            if (RW == 1'b0) begin
                // Write (push)
                if (count < 4) begin
                    // Store data at current pointer pos
                    stack_mem[ptr] <= dataIn;
                    ptr <= ptr + 2'd1;       // wrap-around automatically by 2-bit pointer
                    count <= count + 3'd1;
                end
                // else ignore push if full
            end else begin
                // Read (pop)
                if (count > 0) begin
                    // Move pointer back before reading
                    ptr <= ptr - 2'd1;
                    // Output data at new pointer position
                    dataOut <= stack_mem[ptr - 2'd1]; 
                    count <= count - 3'd1;
                    // Note: (ptr -1) is correct since ptr is updated one cycle after
                end
                // else ignore pop if empty
            end
        end
        // else no operation when EN=0, retain states
    end

    // Output flags
    assign EMPTY = (count == 3'd0);
    assign FULL  = (count == 3'd4);

endmodule