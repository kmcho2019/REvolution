module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Function to compute next state of a cell given neighbors L, C, R
    function automatic bit rule110_next(bit L, bit C, bit R);
        begin
            // Implementing Rule 110 logic according to the table:
            // Next = 1 for patterns: 110, 101, 011, 010, 001
            // Next = 0 for patterns: 111, 100, 000
            // Encoding neighborhood as 3-bit number: {L,C,R}
            // 7:111->0, 6:110->1, 5:101->1, 4:100->0, 3:011->1, 2:010->1, 1:001->1, 0:000->0
            case ({L,C,R})
                3'b111: rule110_next = 0;
                3'b110: rule110_next = 1;
                3'b101: rule110_next = 1;
                3'b100: rule110_next = 0;
                3'b011: rule110_next = 1;
                3'b010: rule110_next = 1;
                3'b001: rule110_next = 1;
                3'b000: rule110_next = 0;
                default: rule110_next = 0;
            endcase
        end
    endfunction

    integer i;
    reg [511:0] next_q;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Compute next state for all cells
            for (i = 0; i < 512; i = i + 1) begin
                bit L, C, R;
                // Left neighbor q[i+1], or 0 if i=511
                L = (i == 511) ? 1'b0 : q[i+1];
                // Center is q[i]
                C = q[i];
                // Right neighbor q[i-1], or 0 if i=0
                R = (i == 0) ? 1'b0 : q[i-1];
                next_q[i] = rule110_next(L, C, R);
            end
            q <= next_q;
        end
    end

endmodule