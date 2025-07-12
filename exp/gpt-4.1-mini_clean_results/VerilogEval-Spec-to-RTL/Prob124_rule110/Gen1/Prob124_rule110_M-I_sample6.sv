module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [513:0] q_ext; // q extended with 0 at both ends
    assign q_ext = {1'b0, q, 1'b0};

    reg [511:0] next_state;
    integer i;

    always @* begin
        for (i = 0; i < 512; i = i + 1) begin
            // neighbors from extended vector to avoid boundary muxes:
            // left = q_ext[i+2], center = q_ext[i+1], right = q_ext[i]
            // Apply simplified boolean formula for Rule 110:
            // next = (left & ~center) | (center & ~right) | (~center & right)

            next_state[i] = (q_ext[i+2] & ~q_ext[i+1]) 
                            | (q_ext[i+1] & ~q_ext[i]) 
                            | (~q_ext[i+1] & q_ext[i]);
        end
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule