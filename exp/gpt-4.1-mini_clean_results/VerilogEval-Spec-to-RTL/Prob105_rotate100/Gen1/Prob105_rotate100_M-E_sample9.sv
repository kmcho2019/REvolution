module TopModule(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    reg [99:0] storage;        // Holds the loaded data and rotated bits
    reg [6:0]  head_ptr;       // Pointer to the bit considered q[99], range 0 to 99 (7 bits enough for 0-127)

    // Function to compute modulo 100 decrement with wraparound
    function [6:0] dec100;
        input [6:0] val;
        begin
            if (val == 0)
                dec100 = 99;
            else
                dec100 = val - 1;
        end
    endfunction

    // Function to compute modulo 100 increment with wraparound
    function [6:0] inc100;
        input [6:0] val;
        begin
            if (val == 99)
                inc100 = 0;
            else
                inc100 = val + 1;
        end
    endfunction

    integer i;
    reg [6:0] idx;
    
    always @(posedge clk) begin
        if (load) begin
            storage <= data;
            head_ptr <= 0;
        end else begin
            case (ena)
                2'b01: // rotate right by one: decrement head_ptr modulo 100
                    head_ptr <= dec100(head_ptr);
                2'b10: // rotate left by one: increment head_ptr modulo 100
                    head_ptr <= inc100(head_ptr);
                default: 
                    head_ptr <= head_ptr; // hold pointer
            endcase
            storage <= storage; // no change to storage on rotate
        end
    end

    always @(*) begin
        // Map storage bits to q with head_ptr offset:
        // q[99] = storage[head_ptr]
        // q[98] = storage[(head_ptr+1)%100]
        // ...
        // q[0] = storage[(head_ptr+99)%100]
        for (i = 0; i < 100; i = i +1) begin
            idx = head_ptr + i;
            if (idx >= 100)
                idx = idx - 100;
            q[99 - i] = storage[idx];
        end
    end

endmodule