module TopModule (
    input         clk,
    input         load,
    input  [1:0]  ena,
    input  [99:0] data,
    output [99:0] q
);
    // Internal register to hold loaded data
    reg [99:0] reg_data;

    // 7-bit pointer for rotation index: 0 to 99
    reg [6:0] head_ptr;

    wire rotate_left  = (ena == 2'b10);
    wire rotate_right = (ena == 2'b01);

    // Update reg_data and head_ptr synchronously
    always @(posedge clk) begin
        if (load) begin
            reg_data <= data;
            head_ptr <= 7'd0; // reset pointer on load
        end else begin
            // Rotate pointer modulo 100
            if (rotate_left) begin
                // increment head_ptr mod 100
                if (head_ptr == 7'd99)
                    head_ptr <= 7'd0;
                else
                    head_ptr <= head_ptr + 7'd1;
            end else if (rotate_right) begin
                // decrement head_ptr mod 100
                if (head_ptr == 7'd0)
                    head_ptr <= 7'd99;
                else
                    head_ptr <= head_ptr - 7'd1;
            end
            // else no change
        end
    end

    // Function to compute index with wrap-around modulo 100
    function [6:0] wrapped_index;
        input [6:0] base;
        input [6:0] offset;
        reg [7:0] sum;
    begin
        sum = base + offset;
        if (sum >= 8'd100)
            wrapped_index = sum - 8'd100;
        else
            wrapped_index = sum[6:0];
    end
    endfunction

    // Assemble rotated output q combinationally by indexing reg_data with head_ptr offset
    genvar i;
    wire [99:0] q_wire;
    generate
        for (i=0; i<100; i=i+1) begin : q_assign
            // q[i] = reg_data[(head_ptr + i) mod 100]
            assign q_wire[i] = reg_data[wrapped_index(head_ptr, i)];
        end
    endgenerate

    assign q = q_wire;

endmodule