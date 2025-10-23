module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    reg [99:0] storage;
    reg [6:0] ptr;  // 7 bits needed to index 0-99 (max 127)

    // Pointer modulo 100 increment and decrement helper functions
    function [6:0] ptr_inc;
        input [6:0] val;
        begin
            if (val == 99)
                ptr_inc = 0;
            else
                ptr_inc = val + 1;
        end
    endfunction

    function [6:0] ptr_dec;
        input [6:0] val;
        begin
            if (val == 0)
                ptr_dec = 99;
            else
                ptr_dec = val - 1;
        end
    endfunction

    // Combinational function to output rotated data starting at ptr
    function [99:0] rotated_output;
        input [99:0] data_in;
        input [6:0] start_ptr;
        integer i;
        begin
            for (i = 0; i < 100; i = i +1) begin
                rotated_output[i] = data_in[(start_ptr + i) % 100];
            end
        end
    endfunction

    always @(posedge clk) begin
        if (load) begin
            storage <= data;
            ptr <= 0;
        end else begin
            case (ena)
                2'b01: ptr <= ptr_dec(ptr);  // Rotate right: move pointer backward
                2'b10: ptr <= ptr_inc(ptr);  // Rotate left: move pointer forward
                default: ptr <= ptr;          // No rotation
            endcase
        end
    end

    always @(*) begin
        q = rotated_output(storage, ptr);
    end

endmodule