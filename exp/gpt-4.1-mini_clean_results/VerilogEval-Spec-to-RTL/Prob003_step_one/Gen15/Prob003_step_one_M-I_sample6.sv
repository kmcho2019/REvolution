module TopModule(output one);
    // Synthesis directive to ensure constant propagation and no buffering
    (* keep = "true" *)
    assign one = 1'b1;
endmodule