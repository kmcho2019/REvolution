module TopModule (
    input  clk,
    input  L,
    input  q_in,
    input  r_in,
    output reg Q
);

    // Function to select next state input based on L
    function automatic select_input;
        input L_local, q_in_local, r_in_local;
        begin
            if (L_local)
                select_input = r_in_local;
            else
                select_input = q_in_local;
        end
    endfunction

    always @(posedge clk) begin
        Q <= select_input(L, q_in, r_in);
    end

endmodule