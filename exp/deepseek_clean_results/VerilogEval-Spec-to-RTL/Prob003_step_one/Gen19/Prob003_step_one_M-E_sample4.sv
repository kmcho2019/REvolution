module TopModule (output one);
    // Define states
    typedef enum logic {LOW, HIGH} state_t;
    state_t current_state;

    // State machine that always stays HIGH
    always_comb begin
        current_state = HIGH;
    end

    // Output assignment
    assign one = (current_state == HIGH);
endmodule